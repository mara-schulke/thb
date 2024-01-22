import tkinter as tk
from enum import Enum

from ..models.canvas import Effect
from ..models.main import Model
from ..views.main import View, ViewId
from .editor import EditorController


class Menu:
    def __init__(self, controller, model: Model, view: View) -> None:
        bar = tk.Menu(view.root)

        file = tk.Menu(bar, tearoff=0)
        file.add_command(label="Open", command=controller.editor.open)
        file.add_command(label="Save as", command=controller.editor.save)
        file.add_separator()
        file.add_command(label="Exit", command=view.root.quit)

        fx = tk.Menu(bar, tearoff=0)
        fx.add_command(label="Grayscale", command=lambda: controller.editor.apply(Effect.GRAYSCALE))
        fx.add_command(label="Blur", command=lambda: controller.editor.apply(Effect.BLUR))
        fx.add_command(label="Contour", command=lambda: controller.editor.apply(Effect.CONTOUR))
        fx.add_command(label="Detail", command=lambda: controller.editor.apply(Effect.DETAIL))
        fx.add_command(label="Emboss", command=lambda: controller.editor.apply(Effect.EMBOSS))
        fx.add_command(label="Edge Enhance", command=lambda: controller.editor.apply(Effect.EDGE_ENHANCE))
        fx.add_command(label="Sharpen", command=lambda: controller.editor.apply(Effect.SHARPEN))
        fx.add_command(label="Smooth", command=lambda: controller.editor.apply(Effect.SMOOTH))

        bar.add_cascade(label="File", menu=file)
        bar.add_cascade(label="Effects", menu=fx)

        view.root.config(menu=bar)

class Controller:
    def __init__(self, model: Model, view: View) -> None:
        self.view = view
        self.model = model
        self.editor = EditorController(model, view)
        self.menu = Menu(self, model, view)

    def start(self) -> None:
        self.view.start()


# def flip_image():
    # try:
        # if not is_flipped:
            # # open the image and flip it left and right
            # image = Image.open(file_path).transpose(Image.FLIP_LEFT_RIGHT)
            # is_flipped = True
        # else:
            # # reset the image to its original state
            # image = Image.open(file_path)
            # is_flipped = False
        # # resize the image to fit the canvas
        # new_width = int((WIDTH / 2))
        # image = image.resize((new_width, HEIGHT), Image.LANCZOS)
        # # convert the PIL image to a Tkinter PhotoImage and display it on the canvas
        # photo_image = ImageTk.PhotoImage(image)
        # canvas.create_image(0, 0, anchor="nw", image=photo_image)

    # except:
        # showerror(title='Flip Image Error', message='Please select an image to flip!')


# global variable for tracking rotation angle
# rotation_angle = 0

# function for rotating the image
# def rotate_image():
    # try:
        # global image, photo_image, rotation_angle
        # # open the image and rotate it
        
        # image = Image.open(file_path)
        # new_width = int((WIDTH / 2))
        # image = image.resize((new_width, HEIGHT), Image.LANCZOS)
        # rotated_image = image.rotate(rotation_angle + 90)
        # rotation_angle += 90
        # # reset image if angle is a multiple of 360 degrees
        # if rotation_angle % 360 == 0:
            # rotation_angle = 0
            # image = Image.open(file_path)
            # image = image.resize((new_width, HEIGHT), Image.LANCZOS)
            # rotated_image = image
        # # convert the PIL image to a Tkinter PhotoImage and display it on the canvas
        # photo_image = ImageTk.PhotoImage(rotated_image)
        # canvas.create_image(0, 0, anchor="nw", image=photo_image)
    
    # except:
        # showerror(title='Rotate Image Error', message='Please select an image to rotate!')




# function for applying filters to the opened image file
# def apply_filter(filter):
    # global image, photo_image
    # try:
        # # check if the image has been flipped or rotated
        # if is_flipped:
            # # flip the original image left and right
            # flipped_image = Image.open(file_path).transpose(Image.FLIP_LEFT_RIGHT)
            # # rotate the flipped image
            # rotated_image = flipped_image.rotate(rotation_angle)
            # # apply the filter to the rotated image
            # if filter == "Black and White":
                # rotated_image = ImageOps.grayscale(rotated_image)
            # elif filter == "Blur":
                # rotated_image = rotated_image.filter(ImageFilter.BLUR)

            # elif filter == "Contour":
                # rotated_image = rotated_image.filter(ImageFilter.CONTOUR)

            # elif filter == "Detail":
                # rotated_image = rotated_image.filter(ImageFilter.DETAIL)

            # elif filter == "Emboss":
                # rotated_image = rotated_image.filter(ImageFilter.EMBOSS)

            # elif filter == "Edge Enhance":
                # rotated_image = rotated_image.filter(ImageFilter.EDGE_ENHANCE)

            # elif filter == "Sharpen":
                # rotated_image = rotated_image.filter(ImageFilter.SHARPEN)

            # elif filter == "Smooth":
                # rotated_image = rotated_image.filter(ImageFilter.SMOOTH)
                        
            # else:
                # rotated_image = Image.open(file_path).transpose(Image.FLIP_LEFT_RIGHT).rotate(rotation_angle)

        # elif rotation_angle != 0:
            # # rotate the original image
            # rotated_image = Image.open(file_path).rotate(rotation_angle)
            # # apply the filter to the rotated image
            # if filter == "Black and White":
                # rotated_image = ImageOps.grayscale(rotated_image)
                
            # elif filter == "Blur":
                # rotated_image = rotated_image.filter(ImageFilter.BLUR)

            # elif filter == "Contour":
                # rotated_image = rotated_image.filter(ImageFilter.CONTOUR)

            # elif filter == "Detail":
                # rotated_image = rotated_image.filter(ImageFilter.DETAIL)

            # elif filter == "Emboss":
                # rotated_image = rotated_image.filter(ImageFilter.EMBOSS)

            # elif filter == "Edge Enhance":
                # rotated_image = rotated_image.filter(ImageFilter.EDGE_ENHANCE)

            # elif filter == "Sharpen":
                # rotated_image = rotated_image.filter(ImageFilter.SHARPEN)

            # elif filter == "Smooth":
                # rotated_image = rotated_image.filter(ImageFilter.SMOOTH)
                
            # else:
                # rotated_image = Image.open(file_path).rotate(rotation_angle)
                
        # else:
            # # apply the filter to the original image
            # image = Image.open(file_path)
            # if filter == "Black and White":
                # image = ImageOps.grayscale(image)

            # elif filter == "Blur":
                # image = image.filter(ImageFilter.BLUR)

            # elif filter == "Sharpen":
                # image = image.filter(ImageFilter.SHARPEN)

            # elif filter == "Smooth":
                # image = image.filter(ImageFilter.SMOOTH)

            # elif filter == "Emboss":
                # image = image.filter(ImageFilter.EMBOSS)

            # elif filter == "Detail":
                # image = image.filter(ImageFilter.DETAIL)


            # elif filter == "Edge Enhance":
                # image = image.filter(ImageFilter.EDGE_ENHANCE)

            # elif filter == "Contour":
                # image = image.filter(ImageFilter.CONTOUR)


            # rotated_image = image
        
        # # resize the rotated/flipped image to fit the canvas
        # new_width = int((WIDTH / 2))
        # rotated_image = rotated_image.resize((new_width, HEIGHT), Image.LANCZOS)
        # # convert the PIL image to a Tkinter PhotoImage and display it on the canvas
        # photo_image = ImageTk.PhotoImage(rotated_image)
        # canvas.create_image(0, 0, anchor="nw", image=photo_image)
        
    # except:
        # showerror(title='Error', message='Please select an image first!')




# # function for drawing lines on the opened image
# def draw(event):
    # global file_path
    # if file_path:
        # x1, y1 = (event.x - pen_size), (event.y - pen_size)
        # x2, y2 = (event.x + pen_size), (event.y + pen_size)
        # canvas.create_oval(x1, y1, x2, y2, fill=pen_color, outline="", width=pen_size, tags="oval")


# # function for changing the pen color
# def change_color():
    # global pen_color
    # pen_color = colorchooser.askcolor(title="Select Pen Color")[1]



# # function for erasing lines on the opened image
# def erase_lines():
    # global file_path
    # if file_path:
        # canvas.delete("oval")




# def save_image():
    # global file_path, is_flipped, rotation_angle

    # if file_path:
        # # create a new PIL Image object from the canvas
        # image = ImageGrab.grab(bbox=(canvas.winfo_rootx(), canvas.winfo_rooty(), canvas.winfo_rootx() + canvas.winfo_width(), canvas.winfo_rooty() + canvas.winfo_height()))

        # # check if the image has been flipped or rotated
        # if is_flipped or rotation_angle % 360 != 0:
            # # Resize and rotate the image
            # new_width = int((WIDTH / 2))
            # image = image.resize((new_width, HEIGHT), Image.LANCZOS)
            # if is_flipped:
                # image = image.transpose(Image.FLIP_LEFT_RIGHT)
            # if rotation_angle % 360 != 0:
                # image = image.rotate(rotation_angle)

            # # update the file path to include the modifications in the file name
            # file_path = file_path.split(".")[0] + "_mod.jpg"

        # # apply any filters to the image before saving
        # filter = filter_combobox.get()
        # if filter:
            # if filter == "Black and White":
                # image = ImageOps.grayscale(image)

            # elif filter == "Blur":
                # image = image.filter(ImageFilter.BLUR)

            # elif filter == "Sharpen":
                # image = image.filter(ImageFilter.SHARPEN)

            # elif filter == "Smooth":
                # image = image.filter(ImageFilter.SMOOTH)

            # elif filter == "Emboss":
                # image = image.filter(ImageFilter.EMBOSS)

            # elif filter == "Detail":
                # image = image.filter(ImageFilter.DETAIL)

            # elif filter == "Edge Enhance":
                # image = image.filter(ImageFilter.EDGE_ENHANCE)
                
            # elif filter == "Contour":
                # image = image.filter(ImageFilter.CONTOUR)

            # # update the file path to include the filter in the file name
            # file_path = file_path.split(".")[0] + "_" + filter.lower().replace(" ", "_") + ".jpg"

        # # open file dialog to select save location and file type
        # file_path = filedialog.asksaveasfilename(defaultextension=".jpg")

        # if file_path:
            # if askyesno(title='Save Image', message='Do you want to save this image?'):
                # # save the image to a file
                # image.save(file_path)

